# frozen_string_literal: true

require "set"

module FastDevWorkingSet
  class Generator < Jekyll::Generator
    priority :highest

    def generate(site)
      config = site.config["fast_dev_working_set"] || {}
      return unless config["enabled"]

      posts = site.collections["posts"]&.docs || []
      return if posts.empty?

      total_posts = posts.size
      recent_count = positive_integer(config["recent_posts"], 25)
      modified_count = positive_integer(config["modified_posts"], 10)

      recent_posts = posts
        .sort_by { |post| post.date || Time.at(0) }
        .reverse
        .first(recent_count)

      modified_posts = posts
        .sort_by { |post| file_mtime(post.path) }
        .reverse
        .first(modified_count)

      selected_posts = (recent_posts + modified_posts)
        .uniq { |post| post.path }
      selected_posts = include_post_url_dependencies(selected_posts, posts)
        .sort_by { |post| post.date || Time.at(0) }
        .reverse

      posts.replace(selected_posts)
      prune_unrelated_tag_pages(site, selected_posts)

      Jekyll.logger.info(
        "Fast Dev:",
        "Rendering #{selected_posts.size}/#{total_posts} working-set posts"
      )
    end

    private

    def positive_integer(value, fallback)
      integer = value.to_i
      integer.positive? ? integer : fallback
    end

    def file_mtime(path)
      File.exist?(path) ? File.mtime(path) : Time.at(0)
    end

    def include_post_url_dependencies(selected_posts, all_posts)
      posts_by_url_key = all_posts.each_with_object({}) do |post, posts|
        key = post.relative_path
          .tr("\\", "/")
          .sub(%r{\A_posts/}, "")
          .sub(/\.md\z/, "")

        posts[key] = post
        posts["/#{key}"] = post
      end

      selected_by_path = selected_posts.each_with_object({}) do |post, posts|
        posts[post.path] = post
      end
      queue = selected_posts.dup

      until queue.empty?
        post = queue.shift

        post.content.scan(/{%\s*post_url\s+([^%\s]+)\s*%}/).flatten.each do |post_url|
          dependency = posts_by_url_key[post_url]
          next unless dependency
          next if selected_by_path.key?(dependency.path)

          selected_by_path[dependency.path] = dependency
          queue << dependency
        end
      end

      selected_by_path.values
    end

    def prune_unrelated_tag_pages(site, selected_posts)
      selected_tags = selected_posts.flat_map { |post| Array(post.data["tags"]) }.to_set

      site.pages.delete_if do |page|
        page.data["layout"] == "tag" && !selected_tags.include?(page.data["tag"])
      end
    end
  end
end

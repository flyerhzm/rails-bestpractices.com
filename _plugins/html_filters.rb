# encoding: utf-8
require 'rubygems'
require 'nokogiri'

module Jekyll
  module TruncateHTMLFilter

    def truncatehtml(raw, max_length = 15, continuation_string = "...")
      doc = Nokogiri::HTML(raw)
      current_length = 0;
      deleting = false
      to_delete = []

      depth_first(doc.children.first) do |node|

        if !deleting && node.class == Nokogiri::XML::Text
          current_length += node.text.length
        end

        if deleting
          to_delete << node
        end

        if !deleting && current_length > max_length
          deleting = true

          trim_to_length = current_length - max_length + 1
          node.content = node.text[0..trim_to_length] + continuation_string
        end
      end

      to_delete.map(&:remove)

      doc.inner_html
    end

  private

    def depth_first(root, &block)
      parent = root.parent
      sibling = root.next
      first_child = root.children.first

      yield(root)

      if first_child
        depth_first(first_child, &block)
      else
        if sibling
          depth_first(sibling, &block)
        else
          # back up to the next sibling
          n = parent
          while n && n.next.nil? && n.name != "document"
            n = n.parent
          end

          # To the sibling - otherwise, we're done!
          if n && n.next
            depth_first(n.next, &block)
          end
        end
      end
    end

  end
end

Liquid::Template.register_filter(Jekyll::TruncateHTMLFilter)

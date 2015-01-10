module Jekyll
  class Raw < Liquid::Block

    def parse(tokens)
      @nodelist ||= []
      @nodelist.clear

      while token = tokens.shift
        case token
        when IsTag
          if token =~ FullToken
            if block_delimiter == $1
              end_tag
              return
            end
            @nodelist << token
          else
            raise SyntaxError, "Tag '#{token}' was not properly terminated with regexp: #{TagEnd.inspect} "
          end
        else
          @nodelist << token
        end
      end

      # Make sure that its ok to end parsing in the current block.
      # Effectively this method will throw and exception unless the current block is
      # of type Document
      assert_missing_delimitation!
    end
  end
end

Liquid::Template.register_tag('raw', Jekyll::Raw)


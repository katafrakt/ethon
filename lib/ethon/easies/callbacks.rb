module Ethon
  module Easies
    module Callbacks
      def set_callbacks
        unless defined?(@body_write_callback)
          Curl.set_option(:writefunction, body_write_callback, handle)
          Curl.set_option(:headerfunction, header_write_callback, handle)
        end
        @response_body = ""
        @response_header = ""
      end

      def body_write_callback
        @body_write_callback ||= proc {|stream, size, num, object|
          @response_body << stream.read_string(size * num)
          size * num
        }
      end

      def header_write_callback
        @header_write_callback ||= proc {|stream, size, num, object|
          @response_header << stream.read_string(size * num)
          size * num
        }
      end

      def read_callback
        @read_callback ||= proc {|stream, size, num, object|
          size = size * num
          left = Utils.bytesize(@request_body) - @request_body_read
          size = left if size > left
          if size > 0
            stream.write_string(Utils.byteslice(@request_body, @request_body_read, size), size)
            @request_body_read += size
          end
          size
        }
      end
    end
  end
end
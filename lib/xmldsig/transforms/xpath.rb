module Xmldsig
  class Transforms < Array
    class XPath < Transform
      attr_reader :xpath_query, :namespaces

      REC_XPATH_1991116_QUERY = "(//. | //@* | //namespace::*)"

      def initialize(node, transform_node, namespaces = NAMESPACES)
        @namespaces = namespaces
        @xpath_query = transform_node.xpath("ds:XPath/text()", Xmldsig::NAMESPACES).to_s
        super(node, transform_node)
      end

      def transform
        # Should this be replacing removed nodes with something other than blank lines?
        node.xpath(REC_XPATH_1991116_QUERY)
          .reject { |n| !n.respond_to?(:xpath) } # namespaces dont repond to xpath
          .reject { |n| n.xpath(@xpath_query, xpath_query_namespaces) }
          .map(&:remove)
        node
      end

      private

      def xpath_query_namespaces
        @xpath_query_namespaces ||= node.namespaces.merge(@namespaces)
      end
    end
  end
end

require 'spec_helper'

describe Xmldsig::Transforms::XPath do
  let(:expected_xpath_query) { "not(ancestor-or-self::eb:MessageHeader)" }
  let(:unsigned_xml) { File.read('spec/fixtures/unsigned/with_xpath_algorithm.xml') }
  let(:unsigned_document) { Xmldsig::SignedDocument.new(unsigned_xml) }
  let(:xpath_namespaces) { { "eb" => "http://www.ebxml.org/namespaces/messageHeader" }.merge(Xmldsig::NAMESPACES) }
  let(:transform_node) { unsigned_document.signatures.first.references.first.transforms[1] }
  subject(:xpath_transform) { described_class.new(unsigned_document.document, transform_node, unsigned_document.document.namespaces) }

  it 'reads the xpath' do
    expect(xpath_transform.xpath_query).to eq expected_xpath_query
  end

  it 'filters out the nodes matching the xpath expression' do
    transformed_node = xpath_transform.transform
    all_match_xpath_query = transform_node.children.all? { |n| n.xpath(expected_xpath_query) }
    expect(all_match_xpath_query).to be true
  end
end

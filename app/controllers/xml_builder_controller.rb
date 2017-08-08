require 'xml_builder'
class XmlBuilderController < ApplicationController
  def index
    # TODO: add some buttion on the view for launching the process, some xml representation is needed too
    XmlBuilder.build_xml
  end
end

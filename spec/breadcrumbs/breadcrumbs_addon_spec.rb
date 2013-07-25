require_relative '../spec_helper'

describe BreadcrumbsAddon do
  before :each do
    klass = Class.new do
      attr_reader :id

      def initialize(id, model)
        @id, @model = id, model
      end
    end

    klass.send(:include, PageViewableDouble)
    klass.send(:include, BreadcrumbsAddon)

    model = model_with_master_page_data('id' => 'Romance', 'breadcrumbs' => ['Books', 'Fiction'])

    @romance_page = klass.new('Romance', model)
    @fiction_page = klass.new('Fiction', model)
    @books_page = klass.new('Books', model)

    @unrelated_page = klass.new('Electronics', model)

    @page_rendered_without_master_page_data_breadcrumbs = klass.new('Home', model_with_master_page_data('id' => 'Home'))
  end

  context "is_active_page" do
    it "should say active if current page" do
      @romance_page.is_active_page.should be_true
    end

    it "should say active if not current page but is included in current page's breadcrumbs" do
      @fiction_page.is_active_page.should be_true
      @books_page.is_active_page.should be_true
    end

    it "should say not active if not current page and not in breadcrumbs" do
      @unrelated_page.is_active_page.should be_false
    end
  end

  context "is_current_page" do
    it "should say current if id matches page data id" do
      @romance_page.is_current_page.should be_true
    end

    it "should say not current if id does not match page data id" do
      @fiction_page.is_current_page.should be_false
    end
  end

  context "current_breadcrumbs" do
    it "should return breadcrumbs from master page data" do
      @romance_page.current_breadcrumbs.should == ['Books', 'Fiction']
    end

    it "should return empty if breadcrumbs not present in master page data" do
      @page_rendered_without_master_page_data_breadcrumbs.current_breadcrumbs.should == []
    end
  end

  def model_with_master_page_data(page_data)
    model = double(:model)
    model.stub_chain(:collection, :master, :page_data).and_return(page_data)
    model
  end

  module PageViewableDouble
    def is_active_page
      id == @model.collection.master.page_data['id']
    end
  end
end

module BreadcrumbsAddon
  def self.included(klass)
    klass.class_eval do
      alias_method :is_current_page, :is_active_page
      alias_method :is_active_page, :is_active_page_as_per_breadcrumbs
    end
  end

  def is_active_page_as_per_breadcrumbs
    is_current_page || current_breadcrumbs.include?(id)
  end

  def current_breadcrumbs
    @model.collection.master.page_data['breadcrumbs'] || []
  end
end

Ruhoh.model('pages').send(:include, BreadcrumbsAddon)

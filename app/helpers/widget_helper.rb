module WidgetHelper

  def widget_category_choices
    [['Continuous Integration Status', 'ci_widget']]
  end

  def widget_size_choices
    (DashboardConfig::MIN_WIDGET_WIDTH..DashboardConfig::MAX_WIDGET_WIDTH).map(&:to_s)
  end

  def widgets_hash(widgets)
    widgets.map do |widget|
      {
        uuid: widget.uuid,
        title: widget.title,
        size: widget.size,
        widget_path: widget_path(id: widget.id)
      }
    end
  end

end
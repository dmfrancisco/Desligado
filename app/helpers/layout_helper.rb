# These helper methods can be called in your template to set variables to be used in the
# layout. This module should be included in all views globally, to do so you may need to
# add this line to your ApplicationController
#   helper :layout
module LayoutHelper
  THEME = "activo"
  IMAGES_PATH = "/stylesheets/themes/#{THEME}/images"

  # Returns the path to an icon of the user navigation set of icons
  def user_navigation_icon_path(icon_name)
    "#{IMAGES_PATH}/session/#{icon_name}.png"
  end

  # Icons to represent actions on view tables (show, edit, remove, etc.)
  def icn(name, alt = '', title = alt)
    alt   = t("icons.alt.#{name}")   if alt.empty?
    title = t("icons.title.#{name}") if title.empty?
    image_tag("#{IMAGES_PATH}/icons/24/#{name}.png",
      :mouseover => "#{IMAGES_PATH}/icons/24/#{name}-hover.png",
      :title => "#{alt}", :alt => "#{title}")
  end

  # Simplify submit buttons
  def submit_button(img_src, text, value = '', options = {})
    raw "<button class='button' type='submit' name='submit' value = '#{value}'>"+
      image_tag("#{IMAGES_PATH}/icons/#{img_src}.png") +' '+ text +"</button>"
  end

  # Simplify buttons
  def link_button(img_src, text, url = '', options = {})
    return link_to raw([image_tag("#{IMAGES_PATH}/icons/#{img_src}.png"), text].join(' ')), options, :class => "button" if url.to_s.empty? # back compatibility [FIXME]
    link_to raw([image_tag("#{IMAGES_PATH}/icons/#{img_src}.png"), text].join(' ')), url, {:class => "button"}.merge!(options)
  end

  # Layout helpers from Ryan Bates nifty_generators

  def title(page_title, show_title = true)
    content_for(:title) { h(page_title.to_s) }
    @show_title = show_title
  end

  def show_title?
    @show_title
  end

  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end

  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end

  # Layout helpers from activo-rails
  # https://github.com/jellybob/activo-rails/blob/master/lib/activo/rails/helper.rb

  # Get or set the page title
  #
  # title - The title to set. (optional)
  #
  # Example:
  #   page_title("Hello, world!")
  #   # => "Hello, world!"
  #   page_title
  #   # => "Hello, world!"
  #
  # Returns the page title, first setting it if title is not nil.
  def page_title(title = nil)
    @title = title unless title.nil?
    @title
  end

  # Display an icon
  #
  # name - The icon to display
  # size - One of :small or :large (optional)
  # options - A hash to be passed to the image_tag helper (optional)
  #
  # Example:
  #   icon("add")
  #   # => image_tag("/images/icons/16x16/add.png", :alt => "Add")
  #   icon("new_item", :large)
  #   # => image_tag("/images/icons/32x32/new_item.png, :alt => "New Item")
  #
  # Returns an image tag, ready to be displayed in a template.
  def icon(name, size = :small, options = {})
    return "" if name.nil?

    # dimension = ( (size == :small) ? "16" : "32" ).html_safe
    options[:alt] ||= name.capitalize.gsub("_", " ")

    # image_tag("#{IMAGES_PATH}/icons/#{dimension}x#{dimension}/#{name}.png", {
    #   :alt => options[:alt]
    # })
    image_tag("#{IMAGES_PATH}/icons/#{name}.png", {
      :alt => options[:alt], :title => options[:alt]
    })
  end

  def navigation(options = {}, &block)
    options[:class] ||= "".html_safe
    options[:class].strip!

    menu = NavigationBuilder.new
    yield menu if block_given?

    content_tag("div", options) do
      content_tag("ul", "", :class => "wat-cf") do
        menu.collect { |item|
          content_tag("li", :class => item[:class]) do
            link_to(item[:label], item[:href], item[:link_options])
          end
        }.join("").html_safe
      end
    end
  end

  # Displays a secondary navigation menu
  #
  # options - A hash of attributes to apply to the wrapping div tag
  #
  # Example:
  #   <div class="block">
  #     <%= secondary_navigation do |nav|
  #       nav.item "List People", people_path, :active => true
  #       nav.item "New Person", new_person_path
  #       nav.item "Search", search_path(:type => "people")
  #     end %>
  #     <div class="content">
  #       <h2 class="title">List People</h2>
  #     </div>
  #   </div>
  #
  # Returns a secondary navigation block to be displayed.
  def secondary_navigation(options = {}, &block)
    options[:class] ||= ""
    options[:class] << " secondary-navigation"

    navigation(options, &block)
  end

  # Creates a set of buttons
  #
  # options - A hash of attributes to apply to the wrapping div tag
  #
  # Example:
  #   <div class="block">
  #     <div class="content">
  #       <%= controls do |c|
  #         c.item "Copy", copy_person_path(person), :icon => "copy_person"
  #         c.item "Delete", person_path(person), :method => :delete
  #       end %>
  #     </div>
  #   </div>
  #
  # Returns a set of controls to be displayed.
  def controls(options = {})
    options[:class] ||= "".html_safe
    options[:class] << " control".html_safe
    options[:class].strip!

    items = NavigationBuilder.new
    yield items if block_given?

    content_tag("div", options) do
      items.collect { |item|
        item[:label] = (icon(item[:icon]) + item[:label]).html_safe if item[:icon]
        link_to(item[:label], item[:href], item[:link_options].merge(:class => "button"))
      }.join("").html_safe
    end
  end

  # Displays a breadcrumb trail
  #
  # options - A hash of attributes to apply to the wrapping div tag
  #
  # Example:
  #   <div class="block">
  #     <div class="content">
  #       <h2><%= @news_item.title %></h2>
  #       <p><%= @news_item.content %></p>
  #     </div>
  #     <%= breadcrumbs do |b|
  #       b.item "Home", root_path
  #       b.item "News", news_path
  #       b.item "Awesome New Things", news_path(@news_item), :active => true
  #     %>
  #   </div>
  #
  # Returns the breadcrumb trail.
  def breadcrumbs(options = {})
    items = NavigationBuilder.new
    yield items if block_given?

    options[:class] ||= "".html_safe
    options[:class] << " breadcrumb".html_safe
    options[:class].strip!

    content_tag("div", options) do
      content_tag("ul") do
        items.collect { |item|
          content_tag("li", :class => item[:class]) do
            if item[:active]
              item[:label]
            else
              link_to(item[:label], item[:href])
            end
          end
        }.join("").html_safe
      end
    end
  end

  # Assists in the creation of navigation menus
  class NavigationBuilder
    attr_reader :item_list
    include Enumerable

    def initialize
      @item_list = []
    end

    def each(&blk)
      item_list.each(&blk)
    end

    def item(label, path, options = {})
      options[:class] ||= ""
      options[:class] << " first" if item_list.empty?
      options[:class] << " active" if options[:active]

      options[:link_options] ||= {}
      options[:link_options].merge!(:method => options[:method]) if options[:method]

      item_list << {
        :label => label,
        :href => path,
        :class => options[:class].strip,
        :link_options => options[:link_options],
        :icon => options[:icon],
        :active => !!options[:active]
      }
    end
  end
end

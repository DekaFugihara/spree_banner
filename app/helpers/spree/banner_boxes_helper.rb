module Spree
  module BannerBoxesHelper

    def insert_banner_box(params={})
      params[:category] ||= "home"
      params[:class] ||= "banner"
      params[:style] ||= Spree::Config[:banner_default_style]
      params[:list] ||= false
      @@banner = Spree::BannerBox.enable(params[:category])
      if @@banner.blank?
        return ''
      end
      res = []
      banner = @@banner.sort_by { |ban| ban.position }

      onClick_ga_event = "ga('send', 'event', { eventCategory: 'internal-promotion', eventAction: 'clicked', eventLabel: '#{params[:category]}'});"
      
      if (params[:list])
        content_tag(:ul, banner.map{|ban| content_tag(:li, link_to(image_tag(ban.attachment.url(params[:style].to_sym)), (ban.url.blank? ? "javascript: void(0)" : ban.url), target: (ban.target_blank? ? "_blank" : ""), onClick: onClick_ga_event), :class => params[:class])}.join().html_safe )
      else
        banner.map{|ban| content_tag(:div, link_to(image_tag(ban.attachment.url(params[:style].to_sym), alt: ban.presentation), (ban.url.blank? ? "javascript: void(0)" : ban.url), target: (ban.target_blank? ? "_blank" : ""), onClick: onClick_ga_event), :class => params[:class])}.join().html_safe
      end
    end

    def insert_slider_box(params={})
      params[:category] ||= "home"
      params[:ul_class] ||= "bxslider-home"
      params[:li_class] ||= "clearfix"
      params[:div_class] ||= "slide-image"
      params[:style] ||= Spree::Config[:banner_default_style]
      @@banner = Spree::BannerBox.enable(params[:category])
      if @@banner.blank?
        return ''
      end
      res = []
      banner = @@banner.sort_by { |ban| ban.position }
        
      content_tag :ul, class: params[:ul_class] do
        banner.map do |ban| 
          content_tag :li, class: params[:li_class] do 
            content_tag :div, class: params[:div_class] do 
              link_to(image_tag(ban.attachment.url(params[:style].to_sym), alt: ban.presentation), (ban.url.blank? ? "javascript: void(0)" : ban.url), target: (ban.target_blank? ? "_blank" : ""))
            end
          end
        end.join().html_safe  
      end
      
    end
    
  end
end

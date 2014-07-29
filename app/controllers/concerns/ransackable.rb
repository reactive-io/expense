module Ransackable
  extend ActiveSupport::Concern

  included do
    def ransack(relation, options = {})
      RansackQuery.new(params, relation, options)
    end
  end

  class RansackQuery
    attr_accessor :ransack, :relation
    attr_reader   :result, :counts, :facets, :ranges

    def initialize(params, relation, options = {})
      @params        = params.clone
      @relation      = relation
      @ransack       = @relation.ransack(@params[:q], options)
      @ransack.sorts = @params[:s] if @params[:s]
    end

    def execute!
      ActiveRecord::Base.transaction(isolation: :repeatable_read) do
        process_result
        process_counts
        process_facets
        process_ranges
      end
    end

    private

    def process_result
      @result = @ransack.result.page(page_num).per(page_per).all
    end

    def process_counts
      @counts = {}

      @counts[:page]      = page_num
      @counts[:limit]     = page_per
      @counts[:offset]    = page_offset
      @counts[:returned]  = @result.length
      @counts[:available] = @ransack.result.count
      @counts[:remaining] = @counts[:available] - @counts[:returned] - page_offset
    end

    def process_facets
      if relation.model.respond_to?(:facetable_attributes)
        @facets = (@params[:f] || []).reduce({}) do |memo, item|
          if relation.model.facetable_attributes.map(&:to_s).include?(item.to_s)
            memo[item.to_sym] = relation.ransack(@params[:q]).result.facet(item.to_sym)
          end
          memo
        end
      end
    end

    def process_ranges
      if relation.model.respond_to?(:rangable_attributes)
        @ranges = (@params[:r] || []).reduce({}) do |memo, item|
          if relation.model.rangable_attributes.map(&:to_s).include?(item.to_s)
            memo[item.to_sym] = relation.ransack(@params[:q]).result.range(item.to_sym)
          end
          memo
        end
      end
    end

    def page
      @page ||= @params[:p] || {}
    end

    def page_num
      @page_num ||= page[:num].to_i || 1
    end

    def page_per
      @page_per ||= lambda {
        per = page[:per].to_i || Kaminari.config.default_per_page
        per > page_max ? Kaminari.config.max_per_page : per
      }.call
    end

    def page_max
      @page_max ||= Kaminari.config.max_per_page || 100
    end

    def page_offset
      @page_offset ||= (page_num - 1) * page_per
    end
  end
end

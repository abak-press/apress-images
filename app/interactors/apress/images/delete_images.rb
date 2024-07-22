# frozen_string_literal: true

module Apress
  module Images
    # Public: удаление картинок
    #
    # Examples:
    #   Apress::Images::DeleteImages.new(
    #     image_class: ProductImage,
    #     conditions: ['product_id IS NULL'],
    #     delete_limit: 1_000,
    #     order: 'fingerprint_parent_id DESC NULLS LAST'
    #  ).call
    class DeleteImages
      DELETE_LIMIT = 1
      DEFAULT_CONDITIONS = ['subject_id IS NULL'].freeze

      attr_reader :image_klass, :conditions, :delete_limit, :order

      delegate :transaction, to: :images_klass

      def initialize(options)
        @image_klass = options.fetch(:image_class)
        @image_klass = @image_klass.camelize.constantize if @image_klass.is_a?(String)

        @conditions = options.fetch(:conditions, DEFAULT_CONDITIONS)
        @delete_limit = options.fetch(:delete_limit, DELETE_LIMIT)

        @order = options[:order]
      end

      def call
        images = images_scope.to_a
        return if images.empty?

        images.sort_by! { |image| image.duplicate? ? 0 : 1 }.each(&:destroy)
      end

      private

      def images_scope
        scope = image_klass.where(conditions)
        scope = scope.reorder(order) if order.present?

        scope.limit(delete_limit)
      end
    end
  end
end

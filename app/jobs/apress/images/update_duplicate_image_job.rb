module Apress
  module Images
    class UpdateDuplicateImageJob
      include Resque::Integration

      queue :images

      def self.perform(id, class_name)
        model = class_name.camelize.constantize
        image = model.where(id: id).first!

        return unless image.processing?

        parent = model.where(id: image.fingerprint_parent_id).first!

        return if parent.processing?

        attrs = model.img_attributes.each_with_object({}) do |attr, memo|
          memo[attr] = parent.attributes[attr]
        end
        attrs[:processing] = false

        image.update_attributes!(attrs)
      end
    end
  end
end

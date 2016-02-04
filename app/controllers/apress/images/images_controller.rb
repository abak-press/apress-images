# coding: utf-8

module Apress
  module Images
    class ImagesController < ::ApplicationController
      layout false

      rescue_from(ActionController::ParameterMissing) { head :bad_request }

      # Public: returns json with preview of product images
      #
      # Returns text/json
      #   [{4190=>"/system/imgs/4190/medium/png_image.png"}, {4191=>"processing"}]
      def previews
        previews = model.where(id: params.require(:ids)).map do |img|
          {img.id => img.processing? ? 'processing' : img.img.url(params.fetch(:style, :medium))}
        end

        render json: previews
      end

      # Public: upload images
      # client can send array of files or array of urls for remote images
      # in param :images
      #
      # Returns text/json with images ids
      def upload
        ids = params.require(:images).each_with_object([]) do |file_or_url, memo|
          begin
            memo << uploader.upload(file_or_url).id
          rescue ::ActiveRecord::RecordInvalid => e
            render json: {status: :error, message: e.message}, status: :unprocessable_entity
            return
          end
        end

        render json: {ids: ids}
      end

      # Public: destroy an image. Expects to receive :id in params.
      #
      # Returns http headers with the status code.
      def destroy
        if model.destroy_all(id: params.require(:id)).present?
          head :no_content
        else
          head :unprocessable_entity
        end
      end

      protected

      def uploader
        @uploader ||=
          Apress::Images::UploadService.new(params.require(:model), params.slice(:subject_type, :subject_id, :id))
      end

      def model
        @model ||= Apress::Images::UploadService.image_model(params.require(:model))
      end
    end
  end
end

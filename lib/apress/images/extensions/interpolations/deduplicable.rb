module Apress
  module Images
    module Extensions
      module Interpolations
        module Deduplicable
          BILLION = 1_000_000_000

          def id(attachment, _style_name)
            attachment.duplicate? ? attachment.instance.fingerprint_parent_id : attachment.instance.id
          end

          def id_partition(attachment, style_name)
            case id = id(attachment, style_name)
            when Integer
              id_sequence(id).scan(/\d{3}/).join('/')
            when String
              ('%9.9s' % id).tr(' ', '0').scan(/.{3}/).join('/')
            end
          end

          # Для случая, когда ID изображения перевалил за 1 миллиард.
          def id_sequence(id)
            order = id >= (Rails.application.config.images[:billion_id_start_with] || BILLION) ? '%012d' : '%09d'

            (order % id)
          end
        end
      end
    end
  end
end

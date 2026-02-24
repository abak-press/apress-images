module Apress
  module Images
    # Сервис для разделения выборки на равные части
    # model - Модель, для которой делается разбиение
    # division_number - кол-во интервалов (по умолчанию 4)
    # conditions - доп. условия фильтрации (например: state NOT IN ('archived', 'deleted'))
    #
    # Returns Array - [[1, 2], [3, 4], [5, 6], [7, 8]]
    class ModelRangeDivisionService
      DEFAULT_DIVISION_NUMBER = 4
      private_constant :DEFAULT_DIVISION_NUMBER

      def initialize(model:, division_number: nil, conditions: nil)
        @model = model
        @division_number = division_number || DEFAULT_DIVISION_NUMBER
        @conditions = conditions
      end

      def call
        sql_results = ::ActiveRecord::Base.connection.select_one(<<~SQL).values.map(&:to_i)
          #{sql_query}
        SQL

        ranges(sql_results)
      end

      private

      def sql_query
        query = 'SELECT MIN(id) AS min, MAX(id) AS max'

        percentile_cont = percentile_step.dup

        (@division_number - 1).times do |i|
          query << ", PERCENTILE_CONT(#{percentile_cont}) WITHIN GROUP(ORDER BY ID) AS median_#{i}"

          percentile_cont += percentile_step
        end

        query << " FROM #{@model.table_name}"
        query << " WHERE #{@conditions}" if @conditions

        query
      end

      def percentile_step
        @percentile_step ||= (100 / @division_number).to_f / 100
      end

      def ranges(sql_results)
        result = [
          [
            sql_results[0],
            sql_results[2],
          ],
        ]

        (@division_number - 2).times do |i|
          result << [
            sql_results[i + 2] + 1,
            sql_results[i + 3],
          ]
        end

        result << [
          sql_results[-1] + 1,
          sql_results[1],
        ]

        result
      end
    end
  end
end

class CalculateController < ApplicationController

  def calculate
    query = permitted_params[:query]

    result = CalculateService.calculate!(query)

    redirect_to root_url, with_message(result)
  end

  private

  def permitted_params
    params.permit(:query)
  end

  def with_message(result)
    case result
    when nil
      { alert: 'Ошибка в запросе, попробуйте другой вариант' }
    else
      { notice: 'Результат: ' + result.to_s }
    end
  end
end

class ReportsController < ApplicationController
  def final_settlement
    @trip = Trip.find(params[:id])

    pdf = FinalSettlementPdf.new(@trip)

    send_data pdf.render,
              filename: "#{@trip.name.parameterize}_final_settlement.pdf",
              type: "application/pdf",
              disposition: "attachment"
  end
end
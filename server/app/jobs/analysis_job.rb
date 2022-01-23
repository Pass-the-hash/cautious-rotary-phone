class AnalysisJob < ApplicationJob
  queue_as :default

  def perform(*args)
    # Do something later
    # require 'ruby-fann'
    # puts 'Hello world!'

    inputs = []
    output = []

    CSV.foreach('real_clinical_data_septic_prediction.csv', headers: true) do |row|
      inputs.push [row[1], row[2], row[3], row[4], row[5], row[6], row[7], row[8], row[9], row[10], row[11], row[12],
                   row[13], row[14], row[15], row[16], row[17], row[18],
                   row[19], row[20], row[21], row[22], row[23], row[24]]
      #x_data.push( [row[0].to_f, row[1].to_f] )
      output.push [row[31]]
    end

    inputs.each do |i|
      i.map!(&:to_f)
    end

    output.each do |i|
      i.map!(&:to_f)
    end

    # inputs.each do |i|
    #   puts i.inspect
    #   puts i[2].class
    # end
    # output.each { |i| puts i.inspect }

    train = RubyFann::TrainData.new(inputs: inputs, desired_outputs: output)
    fann = RubyFann::Standard.new(num_inputs: 24, hidden_neurons: [3, 7, 8, 5], num_outputs: 1)
    fann.train_on_data(train, 1000, 100, 0.01) # 1000 max_epochs, 10 errors between reports and 0.1 desired MSE (mean-squared-error)
    fann.save('training')
  end
end
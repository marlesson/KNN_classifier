require '../../KNN_classifier'

# Read dataset

dataset = []
File.open("wine.csv", "r").each_line do |line|
  features = line.split(",")
  dataset << features.collect(&:to_f)
end

# Separate dataset to train (70%) and predict (30%)
dataset.shuffle!

dataset       = dataset.collect{|d| c = d[0]; d[0] = d[-1]; d[-1] = c; d } #change class and the last feature

dataset_train = dataset[0...(dataset.size * 0.7)]
dataset_pred  = dataset[(dataset.size * 0.7)..-1]

# Classifier

knn  = KNNClassifier.new(dataset_train, {normalization: :standard_deviation})

# Predicted values
hit_classify = []
dataset_pred.each do |feature_pred|
  classify = knn.classify(feature_pred, 3)

  # Hit Classify
  hit_classify << feature_pred if(classify == feature_pred.last) 
end

puts "\n"
puts "Total Classify Predicted: #{dataset_pred.size}"
puts "Hit Classify Predicted: #{hit_classify.size} (#{(hit_classify.size.to_f/dataset_pred.size)*100}%)"


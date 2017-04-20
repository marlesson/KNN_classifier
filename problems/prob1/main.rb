# Classify Wine
# Marlesson
#

require '../../KNN_classifier'

# Read dataset
k_hits = {}
vezes  = 100

vezes.times do |t|

  dataset = []
  File.open("wine.csv", "r").each_line do |line|
    features = line.split(",")
    dataset << features.collect(&:to_f)
  end

  # Separate dataset to train (70%) and predict (30%)
  dataset.shuffle!

  _dataset       = dataset.collect{|d| c = d[0]; d[0] = d[-1]; d[-1] = c; d } #change class and the last feature

  dataset_train = _dataset[0...(_dataset.size * 0.7)]
  dataset_pred  = _dataset[(_dataset.size * 0.7)..-1]

  # Classifier
  knn  = KNNClassifier.new(dataset_train, {normalization: :standard_deviation})

  # Predicted values
  k_times = (3..3)

  k_times.each do |k|
   
    puts "#{t}, k: #{k}"
    next if (k%2 == 0)
    
    k_hits[k] ||= 0;

    hit_classify = []
    dataset_pred.each do |feature_pred|
      classify = knn.classify(feature_pred, k)
      puts "#{t} - #{[classify, feature_pred.last].inspect} - #{(classify == feature_pred.last) ? 'OK' : '-' }"

      # Hit Classify
      hit_classify << feature_pred if(classify == feature_pred.last) 
    end

    k_hits[k] += (hit_classify.size.to_f/dataset_pred.size)/vezes
  end
end

fout = File.open("log_k.txt", "w")
k_hits.each do |k, val|
  log = "#{k}, #{val.to_f}"
  fout.puts log
  puts log
end



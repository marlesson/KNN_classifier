#used for mean, standard deviation, etc.
require 'descriptive_statistics'

class KNNClassifier

  attr_reader :dataset, :dataset_normalized

  # dataset = [
  #     [feature1, feature2, feature3, ..., featureN, "class1"],
  #     [feature1, feature2, feature3, ..., featureN, "class2"],
  #     [feature1, feature2, feature3, ..., featureN, "class2"],
  #   ]
  def initialize(dataset = [], options = {})
    @dataset            = dataset
    @dataset_normalized = dataset.dup

    @normalization = options[:normalization] || :linear # linear or standard_deviation

    normalize()
  end

  # This method classify the features, and return de class
  def classify(features, k = 3)
    # # Order by probability

    feature_normalized = get_features_normalized(features)

    res = @dataset_normalized.sort_by do |features_ds|
      distance(features_ds, feature_normalized)
    end

    return res
  end  

  # Returns the distance of the characteristics between two objects
  # default: euclidian
  def distance(features1, features2, type = :euclidian)
    sum = 0
    features1.lenght.times do |i|
      sum += (features1 - features2)**2
    end

    Math::sqrt(sum)
  end

  def count_features
    @dataset.first.size - 1
  end

  private 

  # Normalize dataset 
  def normalize()
    @dataset_normalized.each do |features|
      features = get_features_normalized(features)
    end
  end

  def get_features_normalized(features)
    case @normalization
      when :linear
        normalize_linear(features)
      when :standard_deviation
        normalize_sd(features)
      else
        raise "Normalization not found"
      end
  end
  
  # Normalize dataset with a Normalization by Linear
  def normalize_linear(features)
    # [min, max, mean, sd]
    statistics = get_statistics_of_features

    count_features.times do |fi|
      min, max, mean, sd = statistics[fi]
      features[fi] = (features[fi]-min).to_f/(max-min)
    end
  end

  # Normalize dataset with a Normalization by standard deviation 
  def normalize_sd(features)
    # [min, max, mean, sd]
    statistics = get_statistics_of_features

    count_features.times do |fi|
      min, max, mean, sd = statistics[fi]
      features[fi] = (features[fi]-mean).to_f/(sd)
    end
  end

  # Return the statistics of all features (min, max, mean, sd)
  def get_statistics_of_features
    return  @statistics if  not @statistics.nil?

    # Statistics of features (min, max, mean, sd)
    @statistics  = []

    count_features.times do |i|
      f_min, f_max, f_mean, f_std = statistics_of_features(i)

      @statistics[i] = [f_min, f_max, f_mean, f_std]
    end

    @statistics
  end

  # Return the statistics of feature (min, max, mean, sd)
  def statistics_of_features(index)
    features_of_class = @dataset.collect{|d| d[index]}

    #statistical properties of the feature set
    f_std  = features_of_class.standard_deviation
    f_mean = features_of_class.mean
    f_min  = features_of_class.min
    f_max  = features_of_class.max
    #f_var  = features_of_class.variance    

    return [f_min, f_max, f_mean, f_std]
  end
end


# knn = KNNClassifier.new([
#       [feature1, feature2, feature3, ..., featureN, "class2"],
#       [feature1, feature2, feature3, ..., featureN, "class2"]
#     ])
# 
# knn.classify([feature1, feature2, feature3, ..., featureN])
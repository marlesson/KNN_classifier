require './KNN_classifier'



knn = KNNClassifier.new([[489, "class1"],
                [467, "class1"],
                [524, "class1"],
                [499, "class1"],
                [498, "class1"],
                [477, "class1"],
                [471, "class1"],
                [509, "class1"],
                [492, "class1"],
                [523, "class1"],
                [483, "class1"],
                [501, "class1"],
                [487, "class1"],
                [532, "class1"],
                [465, "class1"],
                [498, "class1"],
                [478, "class1"]], {normalization: :standard_deviation})


puts "#{knn}"
puts "#{knn.dataset_normalized.inspect}"

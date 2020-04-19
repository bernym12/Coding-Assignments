from os import listdir
from math import sqrt,pi,exp
from pickle import dump, load
from project5_setup import retrieve_pairs, save_file, tmalign_parse, retrieve_feature_data, mean, f_x, read_file, open_pickle




def retrieve_test_pairs(pairs):
    training_pairs = list()
    for i in range(int(0.75*len(pairs)+1), len(pairs)):
        tmalign_values = tmalign_parse(pairs[i])
        training_pairs.append((pairs[i], mean(tmalign_values)))
    return training_pairs

def prediction_of_tmalign(w,features):
    tmalign_scores = list()
    for row in features:
        tmalign_scores.append(f_x(w,row[0]))
    return tmalign_scores
        
def squared_error(predicted, real):
    return mean([(real[i] - predicted[i])**2 for i in range(len(predicted))])

if __name__ == "__main__":
    calcs = open_pickle("calcs.pickle")
    priors = open_pickle("priors.pickle")
    tree = open_pickle("tree.pickle")
    w = open_pickle("w_attempt.pickle")
    pairs = retrieve_pairs()
    test_pairs = retrieve_test_pairs(pairs)
    # features = retrieve_feature_data(calcs, priors, tree, test_pairs)
    # save_file("features", features)
    features = open_pickle("features.pickle")
    # results = dict()
    # for i, pair in enumerate(test_pairs):
    #     fx = f_x(w, features[i][0])
    #     results[f"{pair[0][0]},{pair[0][1]}"] = (fx-features[i][1])**2
    #     print(f"Pair: {pair[0]}\nPercent Error: {(fx-features[i][1])**2}")
    # max_pair = max(results, key = results.get)
    # max_value = results[max_pair]
    # min_pair = min(results, key = results.get)
    # min_value = results[min_pair]
    # print(f"Max Pair: {max_pair}\nMax Value: {max_value}")
    # print(f"Min Pair: {min_pair}\nMin Value: {min_value}")
    real_tmalign = [x[-1] for x in test_pairs]
    prediction = prediction_of_tmalign(w, features)
    error = squared_error(prediction, real_tmalign)
    print(f"Squared Error of Entire Test Set: {error}")
    
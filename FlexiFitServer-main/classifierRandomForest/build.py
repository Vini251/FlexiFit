
from sklearn.ensemble import RandomForestClassifier
import pickle

unpick_x = open('fit_x', 'rb')
X = pickle.load(unpick_x)
unpick_y = open('fit_y', 'rb')
y = pickle.load(unpick_y)
clf = RandomForestClassifier(n_estimators=50, max_depth=15, max_features=4)
clf.fit(X, y)
save_rfc = open('classifier', 'wb')
pickle.dump(clf, save_rfc)
print('Done!')

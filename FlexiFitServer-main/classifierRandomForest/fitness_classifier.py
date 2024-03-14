from sklearn.ensemble import RandomForestClassifier
import pickle

# def build_classifier():
#     unpick_x = open('fit_x', 'rb')
#     X = pickle.load(unpick_x)
#     unpick_y = open('fit_y', 'rb')
#     y = pickle.load(unpick_y)
#     clf = RandomForestClassifier(n_estimators=50, max_depth=15, max_features=4)
#     clf.fit(X, y)
#     save_rfc = open('classifier', 'wb')
#     pickle.dump(clf, save_rfc)
#     print('Done!')

def make_prediction():
    loadcls = open('classifier', 'rb')
    cls = pickle.load(loadcls)
    print(cls.predict_proba([[540, True, 400, False, False, False, False, True, False, False, 50, False, 20, 22, 20, False]]))

def make_recommendation(CalorieTarget: int, CardioToday: bool, CardioWeeklyMinutes: int, Day: str, Mode: str, Temp: int, Precipitation: bool, AQI: int, Age: int, BodyMassIndex: float, Gym: bool):
    loadcls = open('classifier', 'rb')
    cls = pickle.load(loadcls)
    PushDay = False
    PullDay = False
    ArmDay = False
    LegDay = False
    if Day == 'push':
        PushDay = True
    elif Day == 'pull':
        PullDay = True
    elif Day == 'arm':
        ArmDay = True
    elif Day == 'leg':
        LegDay = True
    WeightLoss = False
    HealthMaintenance = False
    MuscleGain = False
    if Mode == 'loss':
        WeightLoss = True
    elif Mode == 'maintain':
        HealthMaintenance = True
    elif Mode == 'gain':
        MuscleGain = True
    else:
        raise Exception('Mode parameter must be set to "loss", "maintain", or "gain"; was "' + str(repr(Mode)))
    return cls.predict([[CalorieTarget, CardioToday, CardioWeeklyMinutes, PushDay, PullDay, ArmDay, LegDay, WeightLoss, HealthMaintenance, MuscleGain, Temp, Precipitation, AQI, Age, BodyMassIndex, Gym]])


# What exercise do you get on leg day?
# Basic Recommendation
print(make_recommendation(0, True, 300, 'leg', 'gain', 74, False, 3, 22, 30, True))

# What exercise do you get on leg day if you don't have gym equipment?
# A factor change from the personal model
print(make_recommendation(0, True, 300, 'leg', 'gain', 74, False, 3, 22, 30, False))

# What if you've done your cardio routine and today is arm day?
# A factor change from the user's history
print(make_recommendation(0, True, 300, 'arm', 'gain', 74, False, 3, 22, 30, True))

# What if you haven't done your cardio routine?
# A factor change from the user's history
print(make_recommendation(0, False, 100, 'arm', 'gain', 74, False, 3, 22, 30, True))

# What if you haven't done your cardio routine and the weather isn't very good?
# A factor change from the context
print(make_recommendation(0, False, 100, 'arm', 'gain', 74, True, 3, 22, 30, True))
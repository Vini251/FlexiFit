class Exercise():
    def __init__(self, name: str, intensity: int, cat: int, outdoor: bool, gym: bool, weights: bool, bulk: bool):
        self.name = name
        self.intensity = intensity
        self.category = cat
        self.outdoor = outdoor
        self.gym = gym
        self.weights = weights
        self.bulk = bulk
        self.priority = 0
    def __repr__(self):
        return self.name

cat = {"cardio": 0, "push": 1, "pull": 2, "arm": 3, "leg": 4}

cardio_set = {Exercise("walk", 1, 0, True, False, False, False),
                 Exercise("run", 2, 0, True, False, False, False),
                 Exercise("treadmill run", 2, 0, False, True, False, False),
                 Exercise("bicycle", 1, 0, True, False, False, False),
                 Exercise("swim", 2, 0, True, False, False, False),
                 Exercise("indoor swim", 2, 0, False, True, False, False),
                 Exercise("high knees", 2, 0, False, False, False, False)}

push_set = {Exercise("dumbbell bench", 3, 1, False, True, True, True),
               Exercise("dumbbell incline bench", 4, 1, False, True, True, True),
               Exercise("pushups", 2, 1, False, False, False, True),
               Exercise("cable fly", 3, 1, False, True, True, True)}

pull_set = {Exercise("cable pull down", 2, 2, False, True, True, True),
               Exercise("cable pull ups", 3, 2, False, True, True, True),
               Exercise("dumbbell rows", 3, 2, False, True, True, True),
               Exercise("pull ups", 3, 2, False, False, False, True),
               Exercise("low rows", 3, 2, False, True, True, True),
               Exercise("bodyweight row", 2, 2, False, False, False, True)}

arm_set = {Exercise("lateral raises & front raises", 3, 3, False, True, True, False),
              Exercise("hammer curls", 3, 3, False, True, True, True),
              Exercise("tricep dips", 3, 3, False, True, False, True),
              Exercise("plank", 2, 3, False, False, False, False),
              Exercise("overhead tricep extensions", 3, 3, False, True, True, True),
              Exercise("barbell tricep pullups", 3, 3, False, True, True, True),
              Exercise("incline curls", 3, 3, False, True, True, True),
              Exercise("leg raises", 2, 3, False, False, False, False),
              Exercise("sit ups", 2, 3, False, False, False, False)}

leg_set = {Exercise("squats", 2, 4, False, False, False, True),
              Exercise("weighted squats", 3, 4, False, True, True, True),
              Exercise("lunges", 3, 4, False, False, False, True),
              Exercise("calf raises", 2, 4, False, True, True, True),
              Exercise("leg curls", 3, 4, False, True, True, True),
              Exercise("leg press", 4, 4, False, True, True, True)}

whole_set = cardio_set | push_set | pull_set | arm_set | leg_set

def min_intensity(ex: Exercise):
    if ex.intensity < 1:
        ex.priority -= 2
    return True

def need_cardio(ex: Exercise):
    if ex.category == 0:
        ex.priority += 1
    return True

def need_weights(ex: Exercise):
    if ex.weights:
        ex.priority += 1
    return True

def push_day(ex: Exercise):
    if not (ex.category == 0 or ex.category == 1):
        ex.priority -= 1
    return True

def pull_day(ex: Exercise):
    if not (ex.category == 0 or ex.category == 2):
        ex.priority -= 1
    return True

def arm_day(ex: Exercise):
    if not (ex.category == 0 or ex.category == 3):
        ex.priority -= 1
    return True

def leg_day(ex: Exercise):
    if not (ex.category == 0 or ex.category == 4):
        ex.priority -= 1
    return True

def make_intensity_capper(cap: int):
    def max_cap(ex: Exercise):
        if ex.intensity > cap:
            ex.priority -= 3
        return True
    out = max_cap
    return out

def no_outdoors(ex: Exercise):
    return ex.outdoor == False

def no_cardio(ex: Exercise):
    if ex.category == 0:
        ex.priority -= 2
    return True

def prefer_bulkup(ex: Exercise):
    if ex.bulk:
        ex.priority += 1
    return True

def no_gym(ex: Exercise):
    return ex.gym == False

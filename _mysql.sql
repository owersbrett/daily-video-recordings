SELECT
    H.id id,
    H.userId userId,
    H.verb verb,
    H.value value,
    H.unitIncrement unitIncrement,
    H.valueGoal valueGoal,
    H.suffix suffix,
    H.unitType unitType,
    H.frequencyType frequencyType,
    H.emoji emoji,
    H.streakEmoji streakEmoji,
    H.hexColor hexColor,
    H.createDate createDate,
    H.updateDate updateDate,
    HE.id HE_ID,
    HE.booleanValue HE_BOOLEAN_VALUE,
    HE.integerValue HE_INTEGER_VALUE,
    HE.stringValue HE_STRING_VALUE,
    HE.createDate HE_CREATE_DATE,
    HE.updateDate HE_UPDATE_DATE
FROM
    Habit H
    INNER JOIN HabitEntry HE on H.id = HE.habitId
WHERE
    H.userId = 1
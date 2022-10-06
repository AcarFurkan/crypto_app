 part of '../coin_cubit.dart';

extension AlarmControlTrasactions on CoinCubit{
    void alarmControl(double lastPrice, MainCurrencyModel itemFromDataBase) {
    if (lastPrice < itemFromDataBase.min && itemFromDataBase.isMinAlarmActive) {
      playMusic(
          itemFromDataBase.minAlarmAudio ??
              AudioModel(
                "audio1",
                "assets/audio/sweet_alarm.mp3",
              ),
          itemFromDataBase.isMinLoop!,
          title: LocaleKeys.alarmAlertDialog_min.tr());
      itemFromDataBase.isMinAlarmActive = false;
      if (itemFromDataBase.isMaxAlarmActive == false) {
        itemFromDataBase.isAlarmActive = false;
      }
      addToDb(itemFromDataBase);
      emit(CoinAlarm(
          itemFromDataBase: itemFromDataBase,
          message:
              "${itemFromDataBase.name.toUpperCase()} ${LocaleKeys.alarmAlertDialog_min.tr()}"));
    } else if (lastPrice > itemFromDataBase.max &&
        itemFromDataBase.isMaxAlarmActive &&
        itemFromDataBase.max != 0) {
      playMusic(
          itemFromDataBase.maxAlarmAudio ??
              AudioModel("audio1", "assets/audio/sweet_alarm.mp3"),
          itemFromDataBase.isMaxLoop!,
          title:
              "${itemFromDataBase.name.toUpperCase()} ${LocaleKeys.alarmAlertDialog_max.tr()}");
      itemFromDataBase.isMaxAlarmActive = false;
      if (itemFromDataBase.isMinAlarmActive == false) {
        itemFromDataBase.isAlarmActive = false;
      }
      addToDb(itemFromDataBase);
      emit(CoinAlarm(
          itemFromDataBase: itemFromDataBase,
          message:
              "${itemFromDataBase.name.toUpperCase()} ${LocaleKeys.alarmAlertDialog_max.tr()}"));
    }
  }

    void stopAudio() => AudioManager.instance.stop();

  Future<void> playMusic(AudioModel audioModel, bool isLoop,
      {required String title}) async {
    //TODO: CHANGE TRY CACHE METHOD YOU MANAGE IT FROM AUDIOMANAGER

    if (audioModel.name == "vibration") {
      final Iterable<Duration> pauses = [
        const Duration(milliseconds: 500),
        const Duration(milliseconds: 1000),
        const Duration(milliseconds: 500),
        const Duration(milliseconds: 1000),
        const Duration(milliseconds: 500),
        const Duration(milliseconds: 1000),
        const Duration(milliseconds: 500),
        const Duration(milliseconds: 1000),
        const Duration(milliseconds: 500),
      ];
      Vibrate.vibrateWithPauses(pauses);
      AudioManager.instance.play(
        audioModel,
        isLoop: isLoop,
        title: title,
        time: context.ultraHighDuration.inSeconds * 2,
      );
    } else {
      try {
        if (isLoop) {
          AudioManager.instance.play(audioModel, isLoop: isLoop, title: title);
        } else {
          AudioManager.instance.play(audioModel,
              isLoop: isLoop,
              time: context.ultraHighDuration.inSeconds * 2,
              title: title);
        }
      } catch (e) {
        print(e);
      }
    }
  }
}
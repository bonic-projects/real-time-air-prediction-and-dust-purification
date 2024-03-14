import 'package:air_guard/ui/common/app_colors.dart';
import 'package:air_guard/ui/smart_widgets/online_status.dart';
import 'package:air_guard/ui/views/home/home_viewmodel.dart';
import 'package:air_guard/ui/views/home/widgets/auto_manual.dart';
import 'package:air_guard/ui/views/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      builder: (context, model, child) {
        return Scaffold(
            appBar: AppBar(
              title: const Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  'AirGuard',
                  style: TextStyle(
                      color: kcPrimaryColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 22),
                ),
              ),
              actions: [
                TextButton(
                    onPressed: model.logout,
                    child: const Row(
                      children: [Text("Logout"), Icon(Icons.logout)],
                    ))
              ],
            ),
            body: SafeArea(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const IsOnlineWidget(),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              const Text("Automatic"),
                              AutoSwitch(
                                  isAuto: model.isAuto,
                                  onClick: model.autoButton),
                            ],
                          )
                        ],
                      ),
                      Column(
                        children: [
                          GridView.count(
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            children: [
                              ReadingCard(
                                text: "Dust",
                                value: model.node?.dust,
                              ),
                              ReadingCard(
                                text: "Humidity",
                                value: model.node?.humi.toDouble(),
                              ),
                              ReadingCard(
                                text: "mq135",
                                value: model.node?.mq135.toDouble(),
                              ),
                              ReadingCard(
                                text: "mq4",
                                value: model.node?.mq4.toDouble(),
                              ),
                              ReadingCard(
                                text: "mq7",
                                value: model.node?.mq7.toDouble(),
                              ),
                              ReadingCard(
                                text: "temp",
                                value: model.node?.temp,
                              ),
                            ],
                          ),
                          Center(
                              child: CustomButton(
                            isDisabled: model.isAuto,
                            onTap: model.buttonToggle,
                            text: model.isAuto
                                ? "Automatic Mode on"
                                : (model.buttonEnable
                                    ? "Relay Off"
                                    : "Turn relay On"),
                            isLoading: model.isBusy,
                            color: model.isAuto
                                ? const Color.fromARGB(255, 206, 217, 224)
                                : (model.buttonEnable
                                    ? Colors.blueGrey
                                    : const Color.fromARGB(255, 53, 92, 124)),
                          )),
                        ],
                      ),
                    ],
                  )),
            ));
      },
      viewModelBuilder: () => HomeViewModel(),
    );
  }
}

class ReadingCard extends StatelessWidget {
  final String text;
  final double? value;

  const ReadingCard({
    Key? key,
    required this.text,
    this.value,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blueGrey,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          children: [
            Text(
              text,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
            const Divider(
              thickness: 1,
            ),
            Text(
              value.toString(),
              style: const TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}

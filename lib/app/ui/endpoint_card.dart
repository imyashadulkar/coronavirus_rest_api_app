import 'package:coronavirus_rest_api_app/app/services/api.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class EndpointCardData {
  final String title;
  final String assetName;
  final Color color;

  EndpointCardData(this.title, this.assetName, this.color);
}

class EndpointCard extends StatelessWidget {
  final Endpoint? endpoints;
  final int? value;

  const EndpointCard({
    Key? key,
    this.endpoints,
    this.value,
  }) : super(key: key);

  static Map<Endpoint, EndpointCardData> _cardTitles = {
    Endpoint.cases:
        EndpointCardData("Cases", "assets/count.png", Color(0xffFFF492)),
    Endpoint.casesSuspected: EndpointCardData(
        "Suspected cases", "assets/suspect.png", Color(0xffEEDA28)),
    Endpoint.casesConfirmed: EndpointCardData(
        "Confirmed cases", "assets/fever.png", Color(0xffE99600)),
    Endpoint.deaths:
        EndpointCardData("Deaths", "assets/death.png", Color(0xffE40000)),
    Endpoint.recovered:
        EndpointCardData("Recovered", "assets/patient.png", Color(0xff70A901))
  };

  String get formattedValue {
    if (value == null) {
      return '';
    }
    return NumberFormat('#,###,###,###').format(value);
  }

  @override
  Widget build(BuildContext context) {
    final cardData = _cardTitles[endpoints]!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            vertical: 8.0,
            horizontal: 16.0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                cardData.title,
                style: Theme.of(context)
                    .textTheme
                    .headline6!
                    .copyWith(color: cardData.color),
              ),
              SizedBox(height: 4.0),
              SizedBox(
                height: 52,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      cardData.assetName,
                      color: cardData.color,
                    ),
                    Text(
                      formattedValue,
                      // value != null ? value.toString() : '',
                      style: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(color: cardData.color),
                      textAlign: TextAlign.end,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

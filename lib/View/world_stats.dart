import 'package:covid_19/Models/WorldStatsModel.dart';
import 'package:covid_19/Services/Stats_Services.dart';
import 'package:covid_19/View/countries_List.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:pie_chart/pie_chart.dart';


class WorldStatsScreen extends StatefulWidget {
  const WorldStatsScreen({super.key});

  @override
  State<WorldStatsScreen> createState() => _WorldStatsScreenState();
}

class _WorldStatsScreenState extends State<WorldStatsScreen> with TickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 3),
    vsync: this,
  )..repeat();
  @override
  void dispose(){
    super.dispose();
    _controller.dispose();
  }
  final colorList=<Color>[
    const Color(0xff4285F4),
    const Color(0xff1aa260),
    const Color(0xffde5246),

  ];
  @override
  Widget build(BuildContext context) {
    StatsServices statsServices=StatsServices();
    return Scaffold(
      body: SafeArea(
          child: Padding(
              padding: EdgeInsets.all(15.0),
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height*.01 ,),
                FutureBuilder(
                    future: statsServices.fetchWorldStatsRecord(),
                    builder: (context,AsyncSnapshot<WorldStatsModel>snapshot){
                      if(!snapshot.hasData){
                        return Expanded(
                          flex: 1,
                            child:SpinKitFadingCircle(
                              color:Colors.white,
                              size: 50.0,
                              controller: _controller,
                            ),
                        );
                      }else{
                        return Column(
                          children: [
                            PieChart(
                              dataMap: {
                                "Total":double.parse(snapshot.data!.cases.toString()),
                                "Recovered":double.parse(snapshot.data!.recovered.toString()),
                                "Deaths":double.parse(snapshot.data!.deaths.toString()),
                              },
                              chartValuesOptions: const ChartValuesOptions(
                                showChartValuesInPercentage: true,
                              ),
                              chartRadius: MediaQuery.of(context).size.width/3.2,
                              legendOptions: const LegendOptions(
                                legendPosition: LegendPosition.left,
                              ),
                              animationDuration: const Duration(milliseconds: 1200),
                              chartType: ChartType.ring,
                              colorList: colorList,

                            ),
                            Padding(
                              padding:EdgeInsets.symmetric(vertical: MediaQuery.of(context).size.height*.06),
                              child: Card(
                                child: Column(
                                  children: [
                                    ReusableRow(title: 'Total',value:snapshot.data!.cases.toString(),),
                                    ReusableRow(title: 'Deaths',value:snapshot.data!.deaths.toString(),),
                                    ReusableRow(title: 'Recovered',value:snapshot.data!.recovered.toString(),),
                                    ReusableRow(title: 'Active',value:snapshot.data!.active.toString(),),
                                    ReusableRow(title: 'Critical',value:snapshot.data!.critical.toString(),),
                                    ReusableRow(title: 'Today Deaths',value:snapshot.data!.todayDeaths.toString(),),
                                    ReusableRow(title: 'today Recovered',value:snapshot.data!.todayRecovered.toString(),),

                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context)=>CountriesListScreen(),
                                  ),
                                );
                              },
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.topRight,
                                    colors: [
                                      Colors.green.shade400,
                                      Colors.greenAccent.shade400,
                                      Colors.lightGreenAccent,
                                      Colors.purpleAccent
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(10),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.green.withOpacity(0.4),
                                      spreadRadius: 1,
                                      blurRadius: 8,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.travel_explore,
                                      color: Colors.black,
                                      size: 24,
                                    ),
                                    SizedBox(width: 10),
                                    Text(
                                      "Track Countries",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        letterSpacing: 1.0,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ),
                          ],
                        );
                      }
    }
                ),

              ],
            ),
          ),
      ),
    );
  }
}


class ReusableRow extends StatelessWidget {
   final String title,value;
  ReusableRow({super.key,required this.title,required this.value});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:EdgeInsets.only(left:10,right: 10,top: 10,bottom: 5 ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title),
              Text(value),
            ],
          ),
          SizedBox(height: 5,),
          Divider()
        ],
      ),
    );
  }
}


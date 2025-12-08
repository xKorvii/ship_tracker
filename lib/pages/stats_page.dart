import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:ship_tracker/components/bottom_navbar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:ship_tracker/theme/theme.dart';
import 'package:ship_tracker/pages/home.dart';
import 'package:provider/provider.dart'; 
import 'package:ship_tracker/providers/order_provider.dart'; 

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  final List<String> dias = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<OrderProvider>(context, listen: false).fetchAndComputeStats();
    });
  }

  Future<bool> _goBackToHome() async {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _goBackToHome();
        }
      },
      child: Consumer<OrderProvider>(
        builder: (context, orderProvider, child) {
          final stats = orderProvider.statsData;

          final completados = List<int>.from(stats['weeklySummary']?['completados'] ?? List.filled(7, 0));
          final pendientes = List<int>.from(stats['weeklySummary']?['pendientes'] ?? List.filled(7, 0));
          final cancelados = List<int>.from(stats['weeklySummary']?['cancelados'] ?? List.filled(7, 0));
          
          final totalCompletadas = (stats['totals']?['Completado']?.toString()) ?? '0';
          final totalPendientes = (stats['totals']?['Pendiente']?.toString()) ?? '0';
          final totalCanceladas = (stats['totals']?['Cancelado']?.toString()) ?? '0';
          
          final monthlyRates = List<int>.from(stats['monthlyRates'] ?? [0, 0, 0, 0, 0]);
          final hasData = stats['hasData'] as bool? ?? false;

  
          double maxY = 0;
          for (int i = 0; i < 7; i++) {
              final maxForDay = (completados[i] + pendientes[i] + cancelados[i]).toDouble();
              if (maxForDay > maxY) {
                  maxY = maxForDay;
              }
          }
          if (maxY == 0) { maxY = 15; } else { maxY = (maxY * 1.2).ceilToDouble(); }


          final List<FlSpot> lineSpots = List.generate(
            monthlyRates.length, 
            (index) => FlSpot(index.toDouble(), monthlyRates[index].toDouble())
          );
          
          final List<LineChartBarData> lineBarsData = [
            LineChartBarData(
              isCurved: true,
              color: verde,
              barWidth: 3,
              dotData: const FlDotData(show: true),
              belowBarData: BarAreaData(show: false),
              spots: lineSpots.isNotEmpty 
                  ? lineSpots 
                  : [const FlSpot(0, 0)],
            ),
          ];

          final List<BarChartGroupData> barGroups = List.generate(dias.length, (i) {
            return BarChartGroupData(
              x: i,
              barsSpace: 4,
              barRods: [
                BarChartRodData(
                  toY: completados[i].toDouble(), 
                  color: verde,
                  width: 10,
                  borderRadius: BorderRadius.circular(4),
                ),
                BarChartRodData(
                  toY: pendientes[i].toDouble(), 
                  color: amarillo, 
                  width: 10,
                  borderRadius: BorderRadius.circular(4),
                ),
                BarChartRodData(
                  toY: cancelados[i].toDouble(),
                  color: rojo,
                  width: 10,
                  borderRadius: BorderRadius.circular(4),
                ),
              ],
            );
          });
          
          if (orderProvider.isLoading && !hasData) {
            return Scaffold(
              backgroundColor: blanco,
              appBar: AppBar(backgroundColor: verde, foregroundColor: blanco, elevation: 0, title: Text('Estadísticas', style: GoogleFonts.archivoBlack(fontSize: 20, color: blanco)), centerTitle: true),
              body: const Center(child: CircularProgressIndicator()),
              bottomNavigationBar: const BottomNavBar(selectedIndex: 2),
            );
          }
          
          if (!hasData && !orderProvider.isLoading) {
            return Scaffold(
              backgroundColor: blanco,
              appBar: AppBar(backgroundColor: verde, foregroundColor: blanco, elevation: 0, title: Text('Estadísticas', style: GoogleFonts.archivoBlack(fontSize: 20, color: blanco)), centerTitle: true),
              body: Center(child: Text("No hay datos de pedidos para mostrar estadísticas.", style: TextStyle(color: grisOscuro))),
              bottomNavigationBar: const BottomNavBar(selectedIndex: 2),
            );
          }

          return Scaffold(
            backgroundColor: blanco,
            appBar: AppBar(
              backgroundColor: verde,
              foregroundColor: blanco,
              elevation: 0,
              automaticallyImplyLeading: true,
              title: Text(
                'Estadísticas',
                style: GoogleFonts.archivoBlack(
                  fontSize: 20,
                  color: blanco,
                ),
              ),
              centerTitle: true,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomePage()),
                  );
                },
              ),
            ),

            body: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: blanco,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: negro,
                            blurRadius: 5,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Pedidos (resumen semanal)',
                                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                'Últimos 7 días',
                                style: TextStyle(fontSize: 12, color: grisOscuro),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 250,
                            child: BarChart(
                              BarChartData(
                                alignment: BarChartAlignment.spaceAround,
                                maxY: maxY, 
                                barTouchData: BarTouchData(enabled: false),
                                titlesData: FlTitlesData(
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 32,
                                      interval: (maxY / 3).ceilToDouble() > 0 ? (maxY / 3).ceilToDouble() : 5, 
                                      getTitlesWidget: (value, meta) => Text(
                                        value.toInt().toString(),
                                        style: const TextStyle(fontSize: 10),
                                      ),
                                    ),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        final index = value.toInt();
                                        if (index >= 0 && index < dias.length) {
                                          return Text(
                                            dias[index],
                                            style: const TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          );
                                        }
                                        return const SizedBox();
                                      },
                                    ),
                                  ),
                                  rightTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false)),
                                  topTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false)),
                                ),
                                gridData: FlGridData(show: true, drawVerticalLine: false),
                                borderData: FlBorderData(show: false),
                                barGroups: barGroups, 
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),


                    const SizedBox(height: 20),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        _MetricCard(
                          color: verde,
                          icon: Icons.check,
                          title: 'Completadas',
                          value: totalCompletadas, 
                        ),
                        _MetricCard(
                          color: amarillo, 
                          icon: Icons.hourglass_bottom,
                          title: 'Pendientes',
                          value: totalPendientes, 
                        ),
                        _MetricCard(
                          color: rojo,
                          icon: Icons.close,
                          title: 'Canceladas',
                          value: totalCanceladas, 
                        ),
                      ],
                    ),

                    const SizedBox(height: 30),

                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: blanco,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: negro,
                            blurRadius: 5,
                            offset: const Offset(2, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Tasa de éxito mensual',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              Text(
                                'Histórico (últimos 5 meses)',
                                style: TextStyle(fontSize: 12, color: grisOscuro),
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: 160,
                            child: LineChart(
                              LineChartData(
                                gridData: FlGridData(
                                  show: true,
                                  drawVerticalLine: false,
                                  getDrawingHorizontalLine: (value) => FlLine(
                                    color: gris,
                                    strokeWidth: 1,
                                  ),
                                ),
                                titlesData: FlTitlesData(
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      reservedSize: 28,
                                      interval: 10,
                                      getTitlesWidget: (value, meta) {
                                        if (value % 10 == 0 && value >= 0) {
                                          return Text(
                                            '${value.toInt()}%',
                                            style: const TextStyle(fontSize: 10),
                                          );
                                        }
                                        return const SizedBox();
                                      },
                                    ),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      interval: 1,
                                      getTitlesWidget: (value, meta) {
                                        switch (value.toInt()) {
                                          case 0: return const Text('P1', style: TextStyle(fontSize: 10));
                                          case 1: return const Text('P2', style: TextStyle(fontSize: 10));
                                          case 2: return const Text('P3', style: TextStyle(fontSize: 10));
                                          case 3: return const Text('P4', style: TextStyle(fontSize: 10));
                                          case 4: return const Text('P5', style: TextStyle(fontSize: 10));
                                          default: return const SizedBox();
                                        }
                                      },
                                    ),
                                  ),
                                  topTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false)),
                                  rightTitles: const AxisTitles(
                                      sideTitles: SideTitles(showTitles: false)),
                                ),
                                borderData: FlBorderData(show: false),
                                minY: 0,
                                maxY: 105,
                                lineBarsData: lineBarsData, 
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            bottomNavigationBar: const BottomNavBar(selectedIndex: 2),
          );
        },
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String value;

  const _MetricCard({
    required this.color,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 95,
      height: 90,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: negro,
            blurRadius: 4,
            offset: const Offset(2, 2),
          ),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: blanco, size: 24),
          const SizedBox(height: 6),
          Text(
            title,
            style: TextStyle(
              color: blanco,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: blanco,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
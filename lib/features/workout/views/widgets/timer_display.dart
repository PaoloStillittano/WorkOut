import 'package:flutter/material.dart';

class TimerDisplay extends StatelessWidget {
  final String currentTime;

  const TimerDisplay({
    super.key,
    required this.currentTime,
  });

  // Metodo per parsare il tempo in modo sicuro
  Map<String, String> _parseTime(String timeString) {
    try {
      // Split iniziale per separare l'ora dal periodo
      final timeParts = timeString.split(' ');
      final period = timeParts.length > 1
          ? timeParts[1]
          : 'AM'; // Default a AM se non presente
      // Split dell'ora per ottenere ore e minuti
      final timeComponents = timeParts[0].split(':');
      final hours = timeComponents[0].padLeft(2, '0');
      final minutes =
          timeComponents.length > 1 ? timeComponents[1].padLeft(2, '0') : '00';
      return {
        'hours': hours,
        'minutes': minutes,
        'period': period,
      };
    } catch (e) {
      // In caso di errore, ritorna valori di default
      return {
        'hours': '00',
        'minutes': '00',
        'period': 'AM',
      };
    }
  }

  @override
  Widget build(BuildContext context) {
    final timeComponents = _parseTime(currentTime);
    final colorScheme = Theme.of(context).colorScheme;
    
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      padding: const EdgeInsets.all(4),
      child: Column(
        children: [          
          // Timer principale
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Card delle ore
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 8.0,
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: FittedBox(
                              child: Text(
                                timeComponents['hours']!,
                                style: TextStyle(
                                  fontSize: 80,
                                  fontWeight: FontWeight.w300,
                                  color: colorScheme.primary,
                                  height: 1,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              child: Text(
                                'H',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: colorScheme.primary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            left: 8,
                            bottom: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              child: Text(
                                timeComponents['period']!.toLowerCase(),
                                style: TextStyle(
                                  fontSize: 14,
                                  color: colorScheme.secondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                
                // Separatore animato
                Container(
                  width: 20,
                  alignment: Alignment.center,
                  child: Text(
                    ':',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.w300,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                
                // Card dei minuti
                Expanded(
                  child: Container(
                    decoration: BoxDecoration(
                      color: colorScheme.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: 20.0,
                        horizontal: 8.0,
                      ),
                      child: Stack(
                        children: [
                          Center(
                            child: FittedBox(
                              child: Text(
                                timeComponents['minutes']!,
                                style: TextStyle(
                                  fontSize: 80,
                                  fontWeight: FontWeight.w300,
                                  color: colorScheme.secondary,
                                  height: 1,
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            right: 8,
                            top: 8,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              child: Text(
                                'M',
                                style: TextStyle(
                                  fontSize: 18,
                                  color: colorScheme.secondary,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
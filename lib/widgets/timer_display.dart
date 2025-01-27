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
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Card delle ore
          Expanded(
            child: Card(
              elevation: 8,
              margin: const EdgeInsets.only(right: 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                child: Stack(
                  children: [
                    Center(
                      child: FittedBox(
                        child: Text(
                          timeComponents['hours']!,
                          style: TextStyle(
                            fontSize: 80,
                            fontWeight: FontWeight.w300,
                            color: textColor,
                            height: 1,
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: 8,
                      bottom: 8,
                      child: Text(
                        timeComponents['period']!.toLowerCase(),
                        style: TextStyle(
                          fontSize: 16,
                          color: textColor?.withOpacity(0.7),
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Card dei minuti
          Expanded(
            child: Card(
              elevation: 8,
              margin: const EdgeInsets.only(left: 4),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                child: Center(
                  child: FittedBox(
                    child: Text(
                      timeComponents['minutes']!,
                      style: TextStyle(
                        fontSize: 80,
                        fontWeight: FontWeight.w300,
                        color: textColor,
                        height: 1,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

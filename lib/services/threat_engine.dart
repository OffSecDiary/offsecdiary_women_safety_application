class ThreatEngine {
  static int calculateRisk({
    required int voiceScore,
    required int motionScore,
    required int faceScore,
    required int locationScore,
  }) {
    return voiceScore +
        motionScore +
        faceScore +
        locationScore;
  }

  static String getThreatLevel(int score) {
    if (score < 30) {
      return "LOW";
    } else if (score < 60) {
      return "MEDIUM";
    } else {
      return "HIGH";
    }
  }
}
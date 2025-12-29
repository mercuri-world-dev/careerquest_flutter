double getAdaptiveDimension(
  double screenDim,
  double proportion,
  double minDim,
  double maxDim,
) {
  return screenDim * proportion < minDim
      ? minDim
      : screenDim * proportion > maxDim
      ? maxDim
      : screenDim * proportion;
}

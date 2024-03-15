function y = SF6Effect(x, Fs)
shift = -6 / 12; % 音调偏移量 (6 个半音)
y_pitched = shiftPitch(x, Fs, shift);
y_filtered = filter(b, a, y_pitched);
y = y_filtered;
end


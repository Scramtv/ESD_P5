## FUNCTIONALITY TEST
    start = time.perf_counter()
    bf_signal = beamforming_das(X_n, d, elements)
    stop = time.perf_counter()
    print(f"{angle}, {bf_signal:.6f}, {np.abs(angle-bf_signal):.6f}, {stop-start:.4f}")
# MATLAB IMU Filtreleme Paketi

## Dosyalar

- `main_demo.m`: Sentetik IMU verisi üretir, EKF ve kuantum-ilhamlı adaptif Kalman filtresini çalıştırır.
- `main_csv_example.m`: ESP32 CSV verisini okur ve filtreye hazırlar.
- `src/filters/classical_ekf_2d.m`: Basitleştirilmiş 2B EKF.
- `src/filters/quantum_inspired_kalman.m`: Deneysel adaptif Kalman filtresi.
- `src/utils/simulate_imu_motion.m`: Örnek IMU hareket verisi üretir.
- `src/visualization/plot_filter_results.m`: Sonuç grafikleri.
- `tests/run_tests.m`: Basit çalışma testi.

## Çalıştırma

```matlab
main_demo
```

CSV örneği:

```matlab
main_csv_example('data/sample_imu_reference.csv')
```

## Not

Bu klasördeki quantum-inspired filtre, gerçek kuantum bilgisayar algoritması değildir. Adaptif ölçüm kovaryansı ve olasılık ağırlıklandırması kullanan deneysel bir modeldir.

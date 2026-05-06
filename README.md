# ESP32 Tabanlı IMU Durum Kestirimi ve Dead-Reckoning Test Platformu

Bu repo, IMU tabanlı durum kestirimi, kör sürüş (dead reckoning), sensör füzyonu ve hata/drift modelleme için hazırlanmış modüler bir test platformudur.

> Durum: GitHub sergileme paketi. Kodlar ve belgeler, prototip geliştirme ve akademik sunum amacıyla düzenlenmiştir. Üretim seviyesi otonom araç yazılımı değildir.

## Projenin amacı

Bu çalışma bir “hazır mobil robot” projesinden çok, IMU verisinin gerçek sistem üzerinde toplanması ve MATLAB ortamında filtreleme/kestirim algoritmalarıyla analiz edilmesi için tasarlanmıştır.

Ana hedefler:

- MPU6050 IMU verisini ESP32 üzerinden CSV formatında toplamak.
- İvmeölçer ve jiroskop verilerindeki bias, drift ve gürültüyü modellemek.
- Klasik EKF ile deneysel/kuantum-ilhamlı Kalman filtre yaklaşımını karşılaştırmak.
- Elektronik bağlantıları, güç dağıtımını ve riskleri proje yönetimi formatında belgelemek.

## Sistem mimarisi

```text
Batarya
  ├── Motor Güç Hattı ──> L298N motor sürücüler ──> DC motorlar
  └── XL4015 Buck 5V ──> ESP32 Dev Board ──> MPU6050 / GPS / yardımcı sensörler

ESP32
  ├── I2C  ──> MPU6050
  ├── UART ──> GPS modülü
  ├── PWM/GPIO ──> L298N sürücüler
  └── USB Serial ──> CSV veri kaydı / MATLAB analizi
```

## Donanım özeti

| Bileşen | Rol | Not |
|---|---|---|
| ESP32 Dev Board | Gerçek zamanlı kontrol ve veri toplama | Ana kontrolcü |
| MPU6050 | 3 eksen ivme + 3 eksen jiroskop | I2C, varsayılan adres `0x68` |
| GPS UART modülü | Konum ve zaman bilgisi | Model net değilse pinleri datasheetten kontrol et |
| XL4015 Buck | 5V lojik besleme | ESP32, IMU ve sensör hattı için |
| L298N | DC motor sürücü | 3 adet sürücü ile 6 motor hedeflenmiştir |
| Ortak GND | Referans potansiyel | Motor ve lojik hatları aynı GND’ye bağlanmalıdır |

## Repo yapısı

```text
firmware/              ESP32 Arduino kodları
matlab/                IMU filtreleme, EKF ve kuantum-ilhamlı Kalman denemeleri
hardware/              Bağlantı şemaları, pin haritaları, perfboard/PCB yerleşim taslakları
docs/                  Teknik belgeler, teori, test ve proje yönetimi notları
project_management/    WBS, risk kayıtları, test matrisi ve sprint planı
assets/                GitHub README görselleri
```

## Hızlı başlatma

### 1. ESP32 veri toplama

Arduino IDE veya PlatformIO ile şu dosyayı aç:

```text
firmware/esp32_imu_logger/esp32_imu_logger.ino
```

Seri port çıktısı CSV formatındadır:

```csv
time_us,ax_g,ay_g,az_g,gx_dps,gy_dps,gz_dps,temp_c
```

### 2. MATLAB demo

MATLAB klasöründe çalıştır:

```matlab
cd matlab
main_demo
```

CSV veriyle çalışmak için:

```matlab
main_csv_example('data/sample_imu_reference.csv')
```

## Filtreleme yaklaşımı

Bu pakette iki ana yaklaşım vardır:

1. **Klasik EKF:** Durum vektörü olarak konum, hız, ivme biası, yönelim ve gyro biası kullanır.
2. **Quantum-inspired Kalman:** Gerçek kuantum donanımı kullanmaz. Ölçüm güvenini, kovaryans güncellemesini ve olasılık ağırlıklandırmasını kuantum benzeri genlik/olasılık mantığıyla uyarlayan deneysel bir adaptif filtredir.

Bu nedenle `quantum_inspired_kalman.m` dosyası akademik olarak “kuantum bilgisayarda çalışan Kalman filtresi” diye sunulmamalıdır. Doğru ifade: **kuantum-ilhamlı adaptif Kalman filtre denemesi**.

## Belgeler

Öne çıkan dosyalar:

- [`docs/Technical_Report.md`](docs/Technical_Report.md)
- [`docs/electronics/Wiring_and_Power.md`](docs/electronics/Wiring_and_Power.md)
- [`docs/research/IMU_Filter_Theory.md`](docs/research/IMU_Filter_Theory.md)
- [`docs/testing/Test_and_Validation.md`](docs/testing/Test_and_Validation.md)
- [`project_management/WBS.md`](project_management/WBS.md)
- [`project_management/risk_register.csv`](project_management/risk_register.csv)

## GitHub’a yükleme

```bash
git init
git add .
git commit -m "initial imu dead reckoning showcase"
git branch -M main
git remote add origin https://github.com/KULLANICI_ADI/REPO_ADI.git
git push -u origin main
```

## Güvenlik notu

Motor sürücüler, batarya ve buck converter birlikte kullanıldığında kısa devre, ısınma ve gerilim düşmesi riski vardır. İlk testlerde motor beslemesini ayrı, ESP32/IMU beslemesini ayrı hat üzerinden ver; yalnızca GND ortak olmalıdır.

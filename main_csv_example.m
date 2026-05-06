function main_csv_example(csv_path)
%MAIN_CSV_EXAMPLE Read ESP32 MPU6050 CSV and prepare data structure.
% CSV header expected:
% time_us,ax_g,ay_g,az_g,gx_dps,gy_dps,gz_dps,temp_c

if nargin < 1
    csv_path = fullfile('data','sample_imu_reference.csv');
end

addpath(genpath('src'));
T = readtable(csv_path);

required = {'time_us','ax_g','ay_g','az_g','gx_dps','gy_dps','gz_dps','temp_c'};
for k = 1:numel(required)
    assert(any(strcmp(T.Properties.VariableNames, required{k})), 'Missing column: %s', required{k});
end

data.t = double(T.time_us(:)') * 1e-6;
data.dt = median(diff(data.t));
data.accel_g = [T.ax_g(:)'; T.ay_g(:)'; T.az_g(:)'];
data.gyro_dps = [T.gx_dps(:)'; T.gy_dps(:)'; T.gz_dps(:)'];

fprintf('Loaded %d samples from %s\n', height(T), csv_path);
fprintf('Estimated sample period: %.6f s (%.2f Hz)\n', data.dt, 1/data.dt);

% Static bias estimate from full file. For real tests use only known stationary interval.
gyro_bias = mean(data.gyro_dps, 2);
accel_mean = mean(data.accel_g, 2);

fprintf('Gyro mean [dps] = [%.4f %.4f %.4f]\n', gyro_bias);
fprintf('Accel mean [g] = [%.4f %.4f %.4f]\n', accel_mean);
end

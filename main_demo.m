clear; clc; close all;

addpath(genpath('src'));

cfg.dt = 0.01;
cfg.T = 20.0;
cfg.accel_noise_std = 0.035;  % g
cfg.gyro_noise_std = 0.8;     % deg/s
cfg.accel_bias_g = [0.018; -0.012];
cfg.gyro_bias_dps = 0.45;

[data, truth] = simulate_imu_motion(cfg);

params.dt = cfg.dt;
params.R_pos = diag([0.08, 0.08].^2);
params.Q = diag([1e-4 1e-4 5e-4 5e-4 2e-4 1e-7 1e-7 1e-7]);
params.R_imu = diag([0.05 0.05 1.0].^2);
params.gravity = 9.80665;

result_ekf = classical_ekf_2d(data, params);
result_qikf = quantum_inspired_kalman(data, params);

plot_filter_results(data, truth, result_ekf, result_qikf);

fprintf('Demo completed. Final EKF position error: %.3f m\n', norm(result_ekf.x(1:2,end) - truth.pos(:,end)));
fprintf('Demo completed. Final Q-inspired position error: %.3f m\n', norm(result_qikf.x(1:2,end) - truth.pos(:,end)));

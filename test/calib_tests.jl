
using Vann
using BlackBoxOptim


################################################################################

# Test calibration of Gr4j

# Read data

filename = joinpath(dirname(@__FILE__), "../data_airgr/test_data.txt")

data = readdlm(filename, ',', header = true)

prec  = data[1][:,1]
epot  = data[1][:,2]
q_obs = data[1][:,3]

prec = transpose(prec)
epot = transpose(epot)

frac = zeros(Float64, 1)

# Select model

st_hydro = Gr4jType(frac)

# Run calibration

res = run_model_calib(st_hydro, prec, epot, q_obs)

# Parameter values

param  = [257.238, 1.012, 88.235, 2.208]

# Test whether calibration gives correct answer

param_range = get_param_range(st_hydro)

println("Finished test calibration of Gr4j")
println(param)
println(res)

for iparam in eachindex(param)

  range_param = param_range[iparam][2] - param_range[iparam][1]

  if !(param[iparam]-0.05*range_param < res[iparam] < param[iparam]+0.05*range_param)
    error("Calibration of gr4j resulted in wrong parameter values")
  end

end


################################################################################

# Test calibration of TinBasic and Gr4j

# Load data

filename = joinpath(dirname(@__FILE__), "../data_atnasjo")

date, tair, prec, q_obs, frac = load_data(filename, "Q_ref.txt")

# Compute potential evapotranspiration

epot = epot_zero(date)

# Select model

st_snow = TinBasicType(frac)
st_hydro = Gr4jType(frac)

# Run calibration

res = run_model_calib(st_snow, st_hydro, date, tair, prec, epot, q_obs)

# Parameter values

param  = [0.0, 3.69, 1.02, 74.59, 0.81, 214.98, 1.24]

# Test whether calibration gives correct answer

param_range_snow  = get_param_range(st_snow)
param_range_hydro = get_param_range(st_hydro)

param_range = vcat(param_range_snow, param_range_hydro)

println("Finished test calibration of TinBasic and Gr4j")
println(param)
println(res)

for iparam in eachindex(param)

  range_param = param_range[iparam][2] - param_range[iparam][1];

  if !(param[iparam]-0.25*range_param < res[iparam] < param[iparam]+0.25*range_param)
    error("Calibration of gr4j + snow resulted in wrong parameter values")
  end

end




# ################################################################################

# # Test calibration of TinStandard and Gr4j

# # Load data

# filename = joinpath(dirname(@__FILE__), "../data_atnasjo")

# date, tair, prec, q_obs, frac = load_data(filename, "Q_ref.txt")

# # Compute potential evapotranspiration

# epot = epot_zero(date)

# # Select model

# st_snow = TinStandardType(frac)
# st_hydro = Gr4jType(frac)

# # Run calibration

# res = run_model_calib(st_snow, st_hydro, date, tair, prec, epot, q_obs)

# println("Finished test calibration of TinStandard and Gr4j")
# println(res)

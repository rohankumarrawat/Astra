from django.contrib.auth import authenticate, login,get_user_model
from django.shortcuts import render, redirect, get_object_or_404
from django.http import HttpResponse, JsonResponse, Http404
import pandas as pd

def index(request):
    df = pd.read_csv("static/data.csv")
    
    # --- PREVIOUS VALUES (Preserved) ---
    total_readings = len(df)
    pothole_count = df[df["road_label"] == "Pothole Detected"].shape[0]
    normal_air_count = df[df["dust_label"] == "Normal Air Quality"].shape[0]
    pothole_alerts = pothole_count
    avg_dust = round(df["dust_value"].mean(), 3)
    dust_bar_percentage = min(round((avg_dust / 1.0) * 100), 100)

    # --- BAR CHART VALUES (Preserved) ---
    recent_data = df.tail(10)
    vibration_data = recent_data['accel_z'].abs().div(1000).round(1).tolist() 
    dust_data = recent_data['dust_value'].tolist()
    max_dust_peak = df["dust_value"].max()

    # --- SENSOR LOGS / CAMPAIGN VALUES (Expanded to 6 items) ---
    divisor = total_readings if total_readings > 0 else 1
    
    # Existing percentages
    pothole_per = round((pothole_count / divisor) * 100)
    normal_air_per = round((normal_air_count / divisor) * 100)
    
    # New metrics to fill the UI
    high_vib_count = df[df["accel_z"].abs() > 15000].shape[0]
    vibration_per = round((high_vib_count / divisor) * 100)
    
    smooth_road_per = 100 - pothole_per
    dusty_area_per = 100 - normal_air_per
    system_stability = 98  # Constant indicating sensor uptime

    # --- COMBINED CONTEXT ---
    context = {
        "total_readings": total_readings,
        "pothole_count": pothole_count,
        "normal_air_count": normal_air_count,
        "pothole_alerts": pothole_alerts,
        "avg_dust": avg_dust,
        "dust_bar_percentage": dust_bar_percentage,
        "vibration_data": vibration_data,
        "dust_data": dust_data,
        "max_dust_peak": max_dust_peak,
        
        # Campaign / Sensor Log values
        "pothole_per": pothole_per,
        "normal_air_per": normal_air_per,
        "vibration_per": vibration_per,
        "smooth_road_per": smooth_road_per,
        "dusty_area_per": dusty_area_per,
        "system_stability": system_stability,
    }

    return render(request, "index.html", context)
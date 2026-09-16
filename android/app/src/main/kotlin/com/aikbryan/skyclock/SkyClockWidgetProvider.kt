package com.aikbryan.skyclock

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin

class SkyClockWidgetProvider : AppWidgetProvider() {

    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        val widgetData = HomeWidgetPlugin.getData(context)
        val cityName = widgetData.getString("widget_city_name", "Lagos") ?: "Lagos"
        val time = widgetData.getString("widget_time", "--:--") ?: "--:--"
        val period = widgetData.getString("widget_period", "Morning") ?: "Morning"

        // Map period to the correct drawable resource
        val imageResId = when (period) {
            "Morning" -> R.drawable.morning
            "Afternoon" -> R.drawable.afternoon
            "Evening" -> R.drawable.evening
            else -> R.drawable.night
        }

        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.skyclock_widget)
            views.setTextViewText(R.id.widget_city_name, cityName)
            views.setTextViewText(R.id.widget_time, time)
            views.setTextViewText(R.id.widget_period, period)
            views.setImageViewResource(R.id.widget_background_image, imageResId)
            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
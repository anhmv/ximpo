using Toybox.WatchUi;
using Toybox.Graphics;
using Toybox.System;
using Toybox.Lang;
using Toybox.ActivityMonitor as Mon;
using Toybox.Time.Gregorian as Date;

class ximpoView extends WatchUi.WatchFace {

    function initialize() {
        WatchFace.initialize();
    }

    // Load your resources here
    function onLayout(dc) {
        setLayout(Rez.Layouts.WatchFace(dc));
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() {
    }

    // Update the view
    function onUpdate(dc) {
        // Get and show the current time
        var clockTime = System.getClockTime();
        var timeString = Lang.format("$1$:$2$", [clockTime.hour, clockTime.min.format("%02d")]);
        var view = View.findDrawableById("TimeLabel");
        view.setText(timeString);

        // Call the parent onUpdate function to redraw the layout
        View.onUpdate(dc); dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_BLACK);
        dc.drawLine(45, dc.getHeight() / 2 - 40, dc.getWidth() - 45, dc.getHeight() / 2 - 40);
        dc.drawLine(45, dc.getHeight() / 2 + 40, dc.getWidth() - 45, dc.getHeight() / 2 + 40);

        dc.drawLine(dc.getWidth() / 2, 40, dc.getWidth() / 2, dc.getHeight() / 2 - 40);
        dc.drawLine(dc.getWidth() / 2, dc.getHeight() / 2 + 40, dc.getWidth() / 2, dc.getHeight() - 40);

        // Battery
    	var battery = System.getSystemStats().battery;
    	dc.drawText(dc.getWidth() / 2 + 15, dc.getHeight() / 2 + 65, Graphics.FONT_XTINY, "BATT", Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(dc.getWidth() / 2 + 15, dc.getHeight() / 2 + 45, Graphics.FONT_XTINY, battery.format("%d")+"%", Graphics.TEXT_JUSTIFY_LEFT);


        // Heart Rate
    	var heartRate = retrieveHeartrateText();
    	dc.drawText(dc.getWidth() / 2 - 15, dc.getHeight() / 2 + 65, Graphics.FONT_XTINY, "HR", Graphics.TEXT_JUSTIFY_RIGHT);
        dc.drawText(dc.getWidth() / 2 - 15, dc.getHeight() / 2 + 45, Graphics.FONT_XTINY, heartRate, Graphics.TEXT_JUSTIFY_RIGHT);

    	// Step Count
       	var stepCount = Mon.getInfo().steps.toString();
    	dc.drawText(dc.getWidth() / 2 - 15, 35, Graphics.FONT_XTINY, "STEPS", Graphics.TEXT_JUSTIFY_RIGHT);
        dc.drawText(dc.getWidth() / 2 - 15, 55, Graphics.FONT_XTINY, stepCount, Graphics.TEXT_JUSTIFY_RIGHT);

        // Date
        var now = Time.now();
        var currentDate = Date.info(now, Time.FORMAT_LONG);

       	var month = Lang.format("$1$", [currentDate.month]).toUpper();
       	var date = Lang.format("$1$", [currentDate.day.format("%02d")]).toUpper();
    	dc.drawText(dc.getWidth() / 2 + 15, 35, Graphics.FONT_XTINY, month, Graphics.TEXT_JUSTIFY_LEFT);
        dc.drawText(dc.getWidth() / 2 + 15, 55, Graphics.FONT_XTINY, date, Graphics.TEXT_JUSTIFY_LEFT);

    }

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() {
    }

    // The user has just looked at their watch. Timers and animations may be started here.
    function onExitSleep() {
    }

    // Terminate any active timers and prepare for slow updates.
    function onEnterSleep() {
    }


    private function retrieveHeartrateText() {
    	var heartrateIterator = Mon.getHeartRateHistory(1, true);

        if (heartrateIterator != null) {
            var hrs = heartrateIterator.next();
            if(hrs != null && hrs.heartRate != null && hrs.heartRate != Mon.INVALID_HR_SAMPLE) {
                return hrs.heartRate.format("%d");
            }
        }

        return "--";
    }
}

package eagleteam.studentsocial

import android.os.Build
import android.os.Bundle
import android.view.ViewTreeObserver
import android.view.WindowManager
import eagleteam.studentsocial.platform_channel.HandlerDatabase
import eagleteam.studentsocial.platform_channel.PlatformChannel.database
import io.flutter.app.FlutterActivity
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant


class MainActivity : FlutterActivity() {
    
    private lateinit var handlerDatabase: HandlerDatabase

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        //make transparent status bar
        makeTransparentStatusBar()
        
        GeneratedPluginRegistrant.registerWith(this)
        //Remove full screen flag after load
        removeFullScreenFlagAfterLoad()
        
        handlerDatabase = HandlerDatabase(application)
        initMethodChanel()
        //tạm thời sẽ đặt mặc định lúc mở app
//        Alarm.create(this) // không đặt thông báo hằng ngày nữa, chuyển sang thông báo hàng loạt flutter side:))
    }

    private fun removeFullScreenFlagAfterLoad() {
        val vto = flutterView.viewTreeObserver
        vto.addOnGlobalLayoutListener(object : ViewTreeObserver.OnGlobalLayoutListener {
            override fun onGlobalLayout() {
                flutterView.viewTreeObserver.removeOnGlobalLayoutListener(this)
                window.clearFlags(WindowManager.LayoutParams.FLAG_FULLSCREEN)
            }
        })
    }

    private fun makeTransparentStatusBar() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.LOLLIPOP) {
            window.statusBarColor = 0x00000000
        }
    }

    private fun initMethodChanel() {
        //for mark
        MethodChannel(flutterView, database).setMethodCallHandler { methodCall, result ->
            handlerDatabase.initMethodChannel(methodCall,result)
        }
    }
}

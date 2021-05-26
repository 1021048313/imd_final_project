package fun.zhon.animecamera;

import androidx.appcompat.app.AppCompatActivity;

import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.widget.Spinner;

public class SplashActivity extends AppCompatActivity {

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
//        setContentView(R.layout.activity_splash);

        System.out.println("ok?");
        Intent intent=new Intent(this,MainActivity.class);
        startActivity(intent);
        finish();

    }
}
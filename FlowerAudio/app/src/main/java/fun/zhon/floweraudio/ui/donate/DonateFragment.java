package fun.zhon.floweraudio.ui.donate;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.lifecycle.Observer;
import androidx.lifecycle.ViewModel;
import androidx.lifecycle.ViewModelProvider;

import fun.zhon.floweraudio.R;
import fun.zhon.floweraudio.ui.donate.DonateFragment;

public class DonateFragment extends Fragment {

    private DonateViewModel donateViewModel;

    public View onCreateView(@NonNull LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {
        donateViewModel =
                new ViewModelProvider(this).get(DonateViewModel.class);
        View root = inflater.inflate(R.layout.fragment_donate, container, false);
        final TextView textView = root.findViewById(R.id.text_donate);
        donateViewModel.getText().observe(getViewLifecycleOwner(), new Observer<String>() {
            @Override
            public void onChanged(@Nullable String s) {
                textView.setText(s);
            }
        });
        return root;
    }
}
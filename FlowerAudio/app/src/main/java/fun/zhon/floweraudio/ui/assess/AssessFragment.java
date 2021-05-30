package fun.zhon.floweraudio.ui.assess;

import android.os.Bundle;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;
import androidx.fragment.app.Fragment;
import androidx.lifecycle.Observer;
import androidx.lifecycle.ViewModelProvider;

import fun.zhon.floweraudio.R;
import fun.zhon.floweraudio.ui.assess.AssessViewModel;

public class AssessFragment extends Fragment {

    private AssessViewModel AssessViewModel;

    public View onCreateView(@NonNull LayoutInflater inflater,
                             ViewGroup container, Bundle savedInstanceState) {
        AssessViewModel =
                new ViewModelProvider(this).get(AssessViewModel.class);
        View root = inflater.inflate(R.layout.fragment_assess, container, false);
        final TextView textView = root.findViewById(R.id.text_assess);
        AssessViewModel.getText().observe(getViewLifecycleOwner(), new Observer<String>() {
            @Override
            public void onChanged(@Nullable String s) {
                textView.setText(s);
            }
        });
        return root;
    }
}
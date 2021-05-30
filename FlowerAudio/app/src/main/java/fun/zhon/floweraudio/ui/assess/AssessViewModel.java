package fun.zhon.floweraudio.ui.assess;

import androidx.lifecycle.LiveData;
import androidx.lifecycle.MutableLiveData;
import androidx.lifecycle.ViewModel;

public class AssessViewModel extends ViewModel {

    private MutableLiveData<String> mText;

    public AssessViewModel() {
        mText = new MutableLiveData<>();
        mText.setValue("This is assess fragment");
    }

    public LiveData<String> getText() {
        return mText;
    }
}
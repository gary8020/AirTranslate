import SwiftUI

struct LiveOutputModePicker: View {
    @Binding var selection: LiveOutputMode
    let isDisabled: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: AirTranslateDesign.Spacing.xxs) {
            Text(AppText.outputMode)
                .font(AirTranslateDesign.Typography.sectionLabel)
                .foregroundStyle(AirTranslateDesign.Palette.textSecondary)

            if isDisabled {
                Label(selection.title, systemImage: "lock.fill")
                    .font(AirTranslateDesign.Typography.label)
                    .foregroundStyle(AirTranslateDesign.Palette.textSecondary)
                    .frame(maxWidth: .infinity, minHeight: 32)
                    .background(AirTranslateDesign.Palette.raisedHover, in: RoundedRectangle(cornerRadius: AirTranslateDesign.Radius.control))
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(AppText.outputMode)
                    .accessibilityValue(selection.title)
                    .accessibilityHint(lockedAccessibilityHint)
            } else {
                Picker(AppText.outputMode, selection: selectionBinding) {
                    ForEach(LiveOutputMode.allCases) { mode in
                        Text(mode.title).tag(mode)
                    }
                }
                .pickerStyle(.segmented)
                .labelsHidden()
                .frame(maxWidth: .infinity)
                .allowsHitTesting(!isDisabled)
                .accessibilityRespondsToUserInteraction(!isDisabled)
                .accessibilityLabel(AppText.outputMode)
                .accessibilityHint(AppText.outputMode)
            }
        }
        .padding(.horizontal, AirTranslateDesign.Spacing.xs)
        .padding(.vertical, AirTranslateDesign.Spacing.xxs)
    }

    private var lockedAccessibilityHint: String {
        AppText.localized(
            english: "Stop capture before changing the output mode.",
            korean: "출력 모드를 바꾸려면 먼저 캡처를 중지하세요.",
            japanese: "出力モードを変更するには、先にキャプチャを停止してください。",
            chineseSimplified: "请先停止采集，再更改输出模式。"
        )
    }

    private var selectionBinding: Binding<LiveOutputMode> {
        Binding(
            get: { selection },
            set: { mode in
                guard !isDisabled else { return }
                selection = mode
            }
        )
    }
}
